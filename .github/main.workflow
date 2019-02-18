workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for npm", "quay.io/egi/ui"]
}

action "GitHub Action for Slack" {
  uses = "Ilshidur/action-slack@4ab30779c772cac48ffe705d27a5a194e3d5ed78"
}

action "GitHub Action for npm" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  secrets = ["GITHUB_TOKEN"]
}

action "run a UI" {
  uses = "quay.io/egi/ui"
  needs = ["GitHub Action for Slack", "GitHub Action for npm"]
  runs = "voms-proxy-info"
}
