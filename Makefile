EXTENSION = pg_idm
DATA = pg_idm--*.sql
# DOCS = README
REGRESS = 001-create-extension 002-create-role

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)