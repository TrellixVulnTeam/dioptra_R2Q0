#!/bin/bash
# This Software (Dioptra) is being made available as a public service by the
# National Institute of Standards and Technology (NIST), an Agency of the United
# States Department of Commerce. This software was developed in part by employees of
# NIST and in part by NIST contractors. Copyright in portions of this software that
# were developed by NIST contractors has been licensed or assigned to NIST. Pursuant
# to Title 17 United States Code Section 105, works of NIST employees are not
# subject to copyright protection in the United States. However, NIST may hold
# international copyright in software created by its employees and domestic
# copyright (or licensing rights) in portions of software that were assigned or
# licensed to NIST. To the extent that NIST holds copyright in this software, it is
# being made available under the Creative Commons Attribution 4.0 International
# license (CC BY 4.0). The disclaimers of the CC BY 4.0 license apply to all parts
# of the software developed or licensed by NIST.
#
# ACCESS THE FULL CC BY 4.0 LICENSE HERE:
# https://creativecommons.org/licenses/by/4.0/legalcode
rm -rf .*.sentinel
rm -rf workflows.tar.gz

make upload-job

docker run --rm -it --volume /home/hhuang/For_Julian:/nfs/data -e "AWS_ACCESS_KEY_ID=minio" -e "AWS_SECRET_ACCESS_KEY=minio123" -e "MLFLOW_EXPERIMENT_NAME=patch-defended-pt" -e "MLFLOW_TRACKING_URI=http://mlflow-tracking:5000" -e "MLFLOW_S3_ENDPOINT_URL=http://minio:9000" --network=patch-defended-pixel-threshold_jtsexton dioptra/tensorflow2-cpu-py37:0.0.0-1 --entry-point pt --s3-workflow s3://workflow/workflows.tar.gz
