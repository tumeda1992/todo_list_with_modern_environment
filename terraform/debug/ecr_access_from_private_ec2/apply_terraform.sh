export $(grep -v '^#' ../../.env | xargs)
export TF_VAR_key_pair_name=${EXISTING_KEY_PAIR_NAME_FOR_DEBUG}
terraform apply