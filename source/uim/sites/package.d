module uim.sites;

@safe:
public import std.stdio;
public import std.uuid;

public import vibe.d;

public import uim.core;
public import uim.oop;
public import uim.html;
// // public import uim.web;

class DSITSite {
  this() {}

  mixin(SProperty!("string", "name"));
  mixin(SProperty!("Session[string]", "sessions"));
  mixin(SProperty!("STRINGAA[string]", "sessionData"));

  Session createSession(this O)(HTTPServerRequest req, HTTPServerResponse res) {
    auto session = res.startSession();
    auto sessionId = randomUUID.toString;
    session.set("sessionID", sessionId);
    sessions[sessionId] = session;
    sessionData[sessionId] = [
      "peer": req.peer,
      "timeCreated": to!string(toTimestamp(req.timeCreated))
    ];
    return session;
  }
  O deleteSession(this O)(HTTPServerRequest req, HTTPServerResponse res) {
    if (res.session) {
      if (res.session.isKeySet("sessionId")) {
        auto sessionId = res.session.get("sessionId");
        sessions.remove(sessionId);
        sessionData.remove(sessionId);
      }
      res.terminateSession();
    }
    return cast(O)this;
  }
}
auto SITSite() { return new DSITSite; }
auto SITSite(string name) { return SITSite.name(name); }

DSITSite[string] mySites;