CREATE TABLE "domains" ( -- local domains
  "domain" varchar(64) NOT NULL,
  "active" boolean NOT NULL default 1
);
CREATE INDEX "all_domains" ON domains ("domain");

CREATE TABLE "aliases" ( -- alias definitions
  "id" integer primary key,
  "username" varchar(128) NOT NULL, -- local-part of email-address
  "domain" varchar(64) NOT NULL, -- domain-part of email-address
  "sendto" varchar(255) NOT NULL, -- address (or more comma-seperated) to forward mail to
  "updated_at" timestamp NOT NULL default CURRENT_TIMESTAMP
);
CREATE INDEX "alias_username" ON aliases ("username");
CREATE INDEX "alias_domain" ON aliases ("domain");

CREATE TABLE "users" ( -- user details and preferences
  "username" varchar(64) NOT NULL, -- localpart of email-address
  "domain" varchar(64) NOT NULL, -- domain-part of email-address
  "password" varchar(28) NOT NULL, -- base64-encoded SHA1 hash of password
  "smtp_allowed" boolean NOT NULL default 1, -- user may receive mail (has a mailbox)
  "imap_allowed" boolean NOT NULL default 1, -- user may fetch mail through pop3/imap
  "spam_threshold" double NOT NULL default '5', -- tag as spam, if above
  "spam_tag" varchar(64) NOT NULL default '{SPAM?} ', -- string to prepend to subject, if spam
  "full_name" varchar(255) default NULL, -- the user''s full name
  "updated_at" timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (username, domain)
);
CREATE INDEX "users_smtp_allowed" ON users ("smtp_allowed");
CREATE INDEX "users_imap_allowed" ON users ("imap_allowed");
CREATE INDEX "users_spam_threshold" ON users ("spam_threshold");


CREATE TABLE "greylists" ( -- greylisting
  "id" integer PRIMARY KEY, -- just a primary key
  "sender_ip" varchar(15) NOT NULL, -- IP of Sender
  "sender_address" varchar(1024) NOT NULL, -- email-address of Sender
  "first_seen" integer NOT NULL -- UNIX TimeStamp of first attempt
);
CREATE INDEX "greylists_sender_ip" ON greylists ("sender_ip");
CREATE INDEX "greylists_sender_address" ON greylists ("sender_address");
