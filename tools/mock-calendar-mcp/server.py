#!/usr/bin/env python3
"""
Mock Calendar MCP server for testing tax-accountant-in-a-box.

Mirrors the tool surface of the real Google Calendar connector closely enough
that client-deadline-calendar runs unchanged, but stores everything in a local
JSON file. No OAuth, no network, no Google account.

Transport: stdio JSON-RPC (MCP). Python standard library only.

Store:  calendar-store.json, next to this file.
Seed:   calendar-seed.json. Copied to the store on first run or after a reset.
"""

import json
import sys
import os
import uuid
from datetime import datetime

HERE = os.path.dirname(os.path.abspath(__file__))
STORE = os.path.join(HERE, "calendar-store.json")
SEED = os.path.join(HERE, "calendar-seed.json")

PROTOCOL_VERSION = "2024-11-05"


# ---------------------------------------------------------------- store

def load_store():
    if not os.path.exists(STORE):
        if os.path.exists(SEED):
            with open(SEED, "r", encoding="utf-8") as f:
                data = json.load(f)
        else:
            data = {
                "calendars": [
                    {"id": "primary", "summary": "Personal", "primary": True},
                    {"id": "tax-deadlines@group.calendar.mock",
                     "summary": "Tax Deadlines", "primary": False},
                ],
                "events": [],
            }
        save_store(data)
        return data
    with open(STORE, "r", encoding="utf-8") as f:
        return json.load(f)


def save_store(data):
    with open(STORE, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)


# ---------------------------------------------------------------- tools

def t_list_calendars(_args):
    return {"calendars": load_store()["calendars"]}


def t_list_events(args):
    data = load_store()
    cal = args.get("calendarId", "primary")
    events = [e for e in data["events"] if e.get("calendarId") == cal]

    # free-text match across title, description and location, AND semantics
    ft = args.get("fullText")
    if ft:
        terms = [t.lower() for t in ft.split() if t.strip()]
        def hit(e):
            blob = " ".join([
                e.get("summary", ""), e.get("description", ""), e.get("location", "")
            ]).lower()
            return all(t in blob for t in terms)
        events = [e for e in events if hit(e)]

    start, end = args.get("startTime"), args.get("endTime")
    if start:
        events = [e for e in events if e.get("startTime", "") >= start]
    if end:
        events = [e for e in events if e.get("startTime", "") <= end]

    events.sort(key=lambda e: e.get("startTime", ""))
    limit = args.get("pageSize", 100)
    return {"events": events[:limit], "totalMatched": len(events)}


def t_create_event(args):
    data = load_store()
    cal = args.get("calendarId", "primary")
    if not any(c["id"] == cal for c in data["calendars"]):
        return {"error": f"No such calendar: {cal}. Call list_calendars first."}

    ev = {
        "id": "evt_" + uuid.uuid4().hex[:12],
        "calendarId": cal,
        "summary": args["summary"],
        "startTime": args["startTime"],
        "endTime": args["endTime"],
        "allDay": args.get("allDay", False),
        "description": args.get("description", ""),
        "colorId": args.get("colorId"),
        "availability": args.get("availability", "AVAILABILITY_BUSY"),
        "visibility": args.get("visibility", "default"),
        "recurrenceData": args.get("recurrenceData", []),
        "created": datetime.utcnow().isoformat() + "Z",
    }
    data["events"].append(ev)
    save_store(data)
    return {"created": ev}


def t_update_event(args):
    data = load_store()
    eid = args["eventId"]
    for e in data["events"]:
        if e["id"] == eid:
            before = dict(e)
            for k in ("summary", "startTime", "endTime", "description",
                      "colorId", "allDay", "availability", "recurrenceData"):
                if k in args:
                    e[k] = args[k]
            save_store(data)
            return {"updated": e, "previous": before}
    return {"error": f"No such event: {eid}"}


def t_delete_event(args):
    data = load_store()
    eid = args["eventId"]
    for i, e in enumerate(data["events"]):
        if e["id"] == eid:
            removed = data["events"].pop(i)
            save_store(data)
            return {"deleted": removed}
    return {"error": f"No such event: {eid}"}


TOOLS = [
    {
        "name": "list_calendars",
        "description": "Returns the calendars available. Use this to resolve a calendar name such as 'Tax Deadlines' into its calendarId.",
        "inputSchema": {"type": "object", "properties": {}},
    },
    {
        "name": "list_events",
        "description": "Returns events on the given calendar. Use fullText to search titles and descriptions, which is how the deadline skill finds the events it previously created via their marker.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "calendarId": {"type": "string", "description": "Defaults to primary."},
                "fullText": {"type": "string", "description": "Free-text AND search over title, description and location."},
                "startTime": {"type": "string", "description": "ISO 8601 lower bound."},
                "endTime": {"type": "string", "description": "ISO 8601 upper bound."},
                "pageSize": {"type": "integer"},
            },
        },
    },
    {
        "name": "create_event",
        "description": "Creates an event on the given calendar.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "calendarId": {"type": "string"},
                "summary": {"type": "string"},
                "startTime": {"type": "string"},
                "endTime": {"type": "string"},
                "allDay": {"type": "boolean"},
                "description": {"type": "string"},
                "colorId": {"type": "string"},
                "availability": {"type": "string"},
                "visibility": {"type": "string"},
                "recurrenceData": {"type": "array", "items": {"type": "string"}},
            },
            "required": ["summary", "startTime", "endTime"],
        },
    },
    {
        "name": "update_event",
        "description": "Updates an existing event by id.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "eventId": {"type": "string"},
                "summary": {"type": "string"},
                "startTime": {"type": "string"},
                "endTime": {"type": "string"},
                "description": {"type": "string"},
                "colorId": {"type": "string"},
                "allDay": {"type": "boolean"},
            },
            "required": ["eventId"],
        },
    },
    {
        "name": "delete_event",
        "description": "Deletes an event by id.",
        "inputSchema": {
            "type": "object",
            "properties": {"eventId": {"type": "string"}},
            "required": ["eventId"],
        },
    },
]

HANDLERS = {
    "list_calendars": t_list_calendars,
    "list_events": t_list_events,
    "create_event": t_create_event,
    "update_event": t_update_event,
    "delete_event": t_delete_event,
}


# ---------------------------------------------------------------- protocol

def reply(rid, result):
    sys.stdout.write(json.dumps({"jsonrpc": "2.0", "id": rid, "result": result}) + "\n")
    sys.stdout.flush()


def reply_error(rid, code, message):
    sys.stdout.write(json.dumps({
        "jsonrpc": "2.0", "id": rid, "error": {"code": code, "message": message}
    }) + "\n")
    sys.stdout.flush()


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue

        method = msg.get("method")
        rid = msg.get("id")

        if method == "initialize":
            reply(rid, {
                "protocolVersion": PROTOCOL_VERSION,
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "mock-calendar", "version": "1.0.0"},
            })

        elif method in ("notifications/initialized", "initialized"):
            pass  # notification, no response

        elif method == "tools/list":
            reply(rid, {"tools": TOOLS})

        elif method == "tools/call":
            params = msg.get("params", {})
            name = params.get("name")
            args = params.get("arguments", {}) or {}
            fn = HANDLERS.get(name)
            if fn is None:
                reply_error(rid, -32601, f"Unknown tool: {name}")
                continue
            try:
                out = fn(args)
                reply(rid, {"content": [{"type": "text", "text": json.dumps(out, indent=2)}]})
            except Exception as exc:  # surface failures as tool errors, not crashes
                reply(rid, {
                    "content": [{"type": "text", "text": f"Error: {exc}"}],
                    "isError": True,
                })

        elif method == "ping":
            reply(rid, {})

        elif rid is not None:
            reply_error(rid, -32601, f"Unknown method: {method}")


if __name__ == "__main__":
    main()
