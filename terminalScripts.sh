alias gs='git status'
alias grh='git reset HEAD --hard'
alias gpus='git pull origin staging'
alias gpos='git push origin staging'
alias gpo='git push origin'
alias gcs='git checkout staging && git pull origin staging'
alias gpum='git pull origin main'
alias gpom='git push origin main'

alias staging='git switch staging'
alias nwt='~/projects/nitro-inventory-wt'
alias ndev='~/projects/nitro-inventory'

# supabase
alias migrations='pnpm exec supabase migration list'
alias migrate='pnpm exec supabase migration up'
alias reset='pnpm exec supabase db reset'
alias migratenew='pnpm exec supabase migration new'