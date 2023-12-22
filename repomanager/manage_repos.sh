#!/bin/bash

known_repos_file="known_repos.txt"

# Check if the known_repos file exists
if [ ! -f "$known_repos_file" ]; then
  echo "Error: File not found: $known_repos_file"
  exit 1
fi

function pull_all_repos() {
  while read -r repo_path; do
    echo "Pulling changes for $repo_path..."
    (cd "$repo_path" && git pull)
  done < "$known_repos_file"
}

function commit_all_repos() {
  local commit_message="AUTO: $(date) on $(hostname)"
  
  while read -r repo_path; do
    echo "Committing changes for $repo_path..."
    (cd "$repo_path" && git add . && git commit -m "$commit_message")
  done < "$known_repos_file"
}

function push_all_repos() {
  while read -r repo_path; do
    echo "Pushing changes for $repo_path..."
    (cd "$repo_path" && git push)
  done < "$known_repos_file"
}

function do_action_for_individual_repo() {
  echo "Enter the number of the repo you want to perform the action on:"
  select repo_path in $(cat "$known_repos_file"); do
    if [ -n "$repo_path" ]; then
      perform_action_on_repo "$repo_path"
      break
    else
      echo "Invalid selection. Please choose a valid repo number."
    fi
  done
}

function perform_action_on_repo() {
  local repo_path="$1"
  local commit_message="AUTO: $(date) on $(hostname)"
  
  echo "Options for $repo_path:"
  echo "1. PULL"
  echo "2. Add and Commit"
  echo "3. Add, Commit, and Push"
  read -p "Enter your choice: " choice

  case "$choice" in
    1)
      (cd "$repo_path" && git pull)
      ;;
    2)
      (cd "$repo_path" && git add . && git commit -m "$commit_message")
      ;;
    3)
      (cd "$repo_path" && git add . && git commit -m "$commit_message" && git push)
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac
}

while :
do
  echo "Options:"
  echo "1. PULL all repos"
  echo "2. Add and Commit all repos"
  echo "3. Add, Commit, and Push all repos"
  echo "4. Perform action for individual repo"
  echo "5. Exit"

  read -p "Enter your choice: " choice

  case "$choice" in
    1)
      pull_all_repos
      ;;
    2)
      commit_all_repos
      ;;
    3)
      push_all_repos
      ;;
    4)
      do_action_for_individual_repo
      ;;
    5)
      exit 0
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac

  read -p "Do you want to restart the script? (y/n): " restart_choice
  if [ "$restart_choice" != "y" ]; then
    exit 0
  fi
done
