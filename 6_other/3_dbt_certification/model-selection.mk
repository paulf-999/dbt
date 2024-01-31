.EXPORT_ALL_VARIABLES:

export PROFILE_DIR_CMD := --profiles-dir=profiles

build:
	#dbt build --select, --exclude, --selector, --resource-type, --defer

compile:
	dbt compile
	#dbt compile --select, --exclude, --selector

ls:
	#dbt ls --select, --exclude, --selector, --resource-type

seed:
	#dbt seed --select, --exclude, --selector

snapshot:
	#dbt snapshot --select, --exclude, --selector

source:
	#dbt source freshness --select, --exclude, --selector
	# example
	dbt source freshness -s source:shared.bp_rel_svw

run:
	#dbt run	--select, --exclude, --selector, --defer

test:
	#dbt test --select, --exclude, --selector, --defer
