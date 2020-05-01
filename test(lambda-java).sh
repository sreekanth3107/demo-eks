#!/bin/bash
rm -f ./cookiecutter-lambda-java.zip
curl -O https://artifactory.healthcareit.net/artifactory/devops-transformation-tools/project-templates/cookiecutter-lambda-java.zip

rm -fR cookiecutter-lambda-java/
unzip -o cookiecutter-lambda-java.zip -d .
cd cookiecutter-lambda-java

rm -f ./cookiecutter.json
echo \{ >> cookiecutter.json
echo   '"kreinto_account_name"': '"folder.AWSAccountPrefix"', >> cookiecutter.json
echo   '"aws_account_id"': '"folder.AWSAccountId"', >> cookiecutter.json
echo   '"kreinto_team_name"': '"NewGroupName"', >> cookiecutter.json
echo   '"business_domain"': '"mydomain"', >> cookiecutter.json
echo   '"func_name"': '"NewProjectName"', >> cookiecutter.json
echo   '"app_id"': '"APP_ID"', >> cookiecutter.json
echo   '"cost_center"': '"COST_CENTER"', >> cookiecutter.json
echo   '"module_domain"': '"{{ cookiecutter.business_domain|lower|replace('\'' '\'', '\'''\'')|replace('\''_'\'', '\'''\'')|replace('\''-'\'', '\'''\'')}}"', >> cookiecutter.json
echo   '"module_name"': '"{{ cookiecutter.func_name|lower|replace('\'' '\'', '\'''\'')|replace('\''_'\'', '\'')|replace('\''--'\'', '\'') }}"', >> cookiecutter.json
#echo   '"team_stage_domain"': '"{{cookiecutter.kreinto_team_name}}'-'dev'-'{{cookiecutter.module_domain}}"', >> cookiecutter.json
#echo   '"team_stage_domain_service"': '"{{cookiecutter.team_stage_domain}}'-'{{cookiecutter.module_name}}"', >> cookiecutter.json
echo   '"git_enabled"': '"no"', >> cookiecutter.json
echo   '"git_repository"': '"git@gitlab.healthcareit.net:{{cookiecutter.kreinto_account_name}}\\{{cookiecutter.kreinto_team_name}}\\{{cookiecutter.func_name}}.git"' >> cookiecutter.json
echo \} >> cookiecutter.json

cd ..
rm -Rf NewProjectName
mkdir NewProjectName
cd NewProjectName
cd ..
cookiecutter --no-input .
