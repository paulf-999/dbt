TOKEN=
ACCOUNT_ID=
JOB_ID=

########################################################
# ACCOUNTS
########################################################
list_accounts:
  curl --request GET \
    --url https://cloud.getdbt.com/api/v2/accounts/ \
    --header "Content-Type: application/json" \
    --header "Authorization: Token ${TOKEN}"

get_accounts:
  curl --request GET \
    --url https://cloud.getdbt.com/api/v2/accounts/${ACCOUNT_ID}/ \
    --header "Content-Type: application/json" \
    --header "Authorization: Token ${TOKEN}"

#######################################################
# PROJECTS
#######################################################
list_projects_from_account
  curl --request GET \
    --url https://cloud.getdbt.com/api/v2/accounts/${ACCOUNT_ID}/projects/ \
    --header "Content-Type: application/json" \
    --header "Authorization: Token ${TOKEN}"

get_project_from_account
  curl --request GET \
    --url https://cloud.getdbt.com/api/v2/accounts/${ACCOUNT_ID}/projects/20293/ \
    --header "Content-Type: application/json" \
    --header "Authorization: Token ${TOKEN}"

#######################################################
# JOBS
#######################################################
list_jobs:
  curl --request GET \
    --url https://cloud.getdbt.com/api/v2/accounts/${ACCOUNT_ID}/jobs/ \
    --header "Content-Type: application/json" \
    --header "Authorization: Token ${TOKEN}"

executes_job:
  #NOTE: this is a POST method
  curl --request POST \
    --url https://cloud.getdbt.com/api/v2/accounts/${ACCOUNT_ID}/jobs/${JOB_ID}/run/ \
    --header "Content-Type: application/json" \
    --header "Authorization: Token ${TOKEN}" \
    --form 'cause=Triggered via API'
