$base = "C:\Users\Veteran\3D Objects\Downloads\shopify-store-builder-pro\shopify-store-builder-pro"
Write-Host "🔧 Creating Phase 2 folders and files under $base" -ForegroundColor Cyan

# Helper
function New-TextFile($path,$content){
  $full = Join-Path $base $path
  New-Item -ItemType Directory -Force -Path (Split-Path $full) | Out-Null
  Set-Content -Path $full -Value $content -Encoding UTF8
  Write-Host "  ✔ $path"
}

# -----------------------------
#  Templates
# -----------------------------
New-TextFile "templates\executive-brief-template.md" @"
# Executive Brief Template

| Client | Project | Start Date | End Date |
|---------|----------|-------------|-----------|
| | | | |

## Objectives
- Summarize project goals and measurable outcomes.

## Milestones
| Phase | Deliverable | Owner | Due | Status |
|-------|--------------|--------|------|--------|

## Success Metrics
- Conversion increase %  
- Cost/time savings  
- Customer satisfaction (NPS)  

## Sign-off
Approved by ______________________ (Date)
"@

New-TextFile "templates\catalog-architecture-template.md" @"
# Catalog Architecture Template

## Product Matrix
| Style | Color | Size | SKU | Price |
|--------|--------|------|------|-------|

## Metafield Schema
| Namespace | Key | Type | Description |
|------------|-----|------|-------------|

## Naming Conventions
- Example: `AA-{{style}}-{{color}}-{{size}}`

## Collection Strategy
- Parent/child collection rules
- Automated vs manual
"@

New-TextFile "templates\launch-checklist.md" @"
# Launch Checklist (100-Item Baseline)

## Pre-Launch
- [ ] Verify theme validation  
- [ ] Test checkout  
- [ ] Confirm GA4 + Pixels active  

## Go-Live
- [ ] DNS propagation verified  
- [ ] Payment gateways active  

## Post-Launch
- [ ] Performance audit  
- [ ] Backup export  
- [ ] Stakeholder sign-off  
"@

# Budget tracker placeholder (user fills manually)
New-Item -ItemType Directory -Force -Path "$base\templates" | Out-Null
Out-File "$base\templates\budget-tracker-template.xlsx"

# -----------------------------
#  Scripts
# -----------------------------
New-TextFile "scripts\setup.js" @"
// 🚀 Shopify Store Builder PRO – Setup Wizard
import inquirer from 'inquirer';
import chalk from 'chalk';
import ora from 'ora';
import fs from 'fs';

(async ()=>{
  console.log(chalk.cyan('\n🚀  Shopify Store Builder PRO – Setup Wizard\n'));
  const spinner = ora('Checking Node.js version…').start();
  const version = process.versions.node.split('.')[0];
  if(version < 18){ spinner.fail('Node 18+ required'); process.exit(1); }
  spinner.succeed('Environment OK');

  const answers = await inquirer.prompt([
    {name:'store', message:'Shopify store URL:'},
    {name:'token', message:'Admin API access token:'}
  ]);

  const env = `SHOPIFY_STORE_DOMAIN=${answers.store}\nSHOPIFY_ACCESS_TOKEN=${answers.token}`;
  fs.writeFileSync('.env', env);
  console.log(chalk.green('\n✅  .env file created! Verify Shopify CLI is installed.\n'));
})();
"@

New-TextFile "scripts\generate-products.js" @"
// Generates product mutations for bulk import
import fs from 'fs';

const products=[
  {title:'Apex T-Shirt Blue S', price:29.99, sku:'AA-BLU-S'},
  {title:'Apex T-Shirt Blue M', price:29.99, sku:'AA-BLU-M'}
];
const mutations = products.map(p=>({
  query:`mutation { productCreate(input:{title:\"${p.title}\",variants:[{price:${p.price},sku:\"${p.sku}\"}]}){product{id}}}`
}));
fs.writeFileSync('deliverables/products.jsonl', mutations.map(m=>JSON.stringify(m)).join('\n'));
console.log('✅  Generated deliverables/products.jsonl');
"@

New-TextFile "scripts\bulk-import.js" @"
// Uploads products via GraphQL bulk operation
import fetch from 'node-fetch';
import fs from 'fs';
const token = process.env.SHOPIFY_ACCESS_TOKEN;
const domain = process.env.SHOPIFY_STORE_DOMAIN;
(async ()=>{
  const data = fs.readFileSync('deliverables/products.jsonl','utf8');
  console.log(`Uploading ${data.split('\n').length} mutations…`);
  // Add GraphQL call here
})();
"@

New-TextFile "scripts\create-collections.js" @"
// Creates collections using Shopify Admin API
console.log('🗂  create-collections.js placeholder – define rules + assignments');
"@

New-TextFile "scripts\validate-theme.js" @"
// Runs shopify theme check
import { execSync } from 'child_process';
try{
  execSync('shopify theme check',{stdio:'inherit'})
