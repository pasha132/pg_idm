EXTENSION = pg_idm
DATA = pg_idm--*.sql
# DOCS = README
REGRESS = $(sort $(patsubst sql/%.sql,%,$(wildcard sql/*.sql)))

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)