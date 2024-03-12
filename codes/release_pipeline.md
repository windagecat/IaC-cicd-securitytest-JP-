# リリースパイプライン
Azure PipelineのReleasesを使用し、 リリースパイプラインを作成します。

![8](./images/8.png)
## Continuous deployment trigger
Artifactsの項目で、continuous deployment triggerの設定をします。

![release_1](./images/release_1.png)

## Stages
下記に、stagesの設定を示します。

- Stage 

![release_2](./images/release_2.png)

- Agent job

![release_3](./images/release_3.png)


- Pipeline variables
> product environmentのterraform.varsファイルを編集した場合、変数「RG」を変更する必要があります。

![release_4](./images/release_4.png)


- Pipeline yaml for tasks
>サービスコネクションとして、 Workload identity federation (OIDC) が推奨されています。
```bash
variables:
  RG: '<resource group name>'
  cluster_name: 'aks_product_cp01'
  acr_name: 'acrproduct'

steps:
- task: ms-devlabs.custom-terraform-tasks.custom-terraform-installer-task.TerraformInstaller@1
  displayName: 'Install Terraform 1.6.6'
  inputs:
    terraformVersion: 1.6.6
  timeoutInMinutes: 5

- task: ms-devlabs.custom-terraform-tasks.custom-terraform-release-task.TerraformTaskV4@4
  displayName: 'Terraform init'
  inputs:
    workingDirectory: '<working directory>'
    backendServiceArm: '<service connection>' #Workload identity federation (OIDC) is recommended 
    backendAzureRmResourceGroupName: '<resource group name>'
    backendAzureRmStorageAccountName: <StorageAccountName>
    backendAzureRmContainerName: 'azure-tfstate'
    backendAzureRmKey: terraform.tfstate
  timeoutInMinutes: 10

- task: ms-devlabs.custom-terraform-tasks.custom-terraform-release-task.TerraformTaskV4@4
  displayName: 'Terraform validate'
  inputs:
    command: validate
    workingDirectory: '<working directory>'
  timeoutInMinutes: 10

- task: ms-devlabs.custom-terraform-tasks.custom-terraform-release-task.TerraformTaskV4@4
  displayName: 'Terraform plan'
  inputs:
    command: plan
    workingDirectory: '<working directory>'
    commandOptions: '-var="resource_group_name=$(RG)" -var="aks_cluster_name=$(cluster_name)" -var="acr_name=$(acr_name)"'
    environmentServiceNameAzureRM: '<service connection>' #Workload identity federation (OIDC) is recommended 
  timeoutInMinutes: 10

- task: ms-devlabs.custom-terraform-tasks.custom-terraform-release-task.TerraformTaskV4@4
  displayName: 'Terraform apply'
  inputs:
    command: apply
    workingDirectory: '<working directory>'
    commandOptions: '-var="resource_group_name=$(RG)" -var="aks_cluster_name=$(cluster_name)" -var="acr_name=$(acr_name)"'
    environmentServiceNameAzureRM: '<service connection>' #Workload identity federation (OIDC) is recommended 
  timeoutInMinutes: 30

```
- Triggers

![5](./images/5.png)

- Gates(Post-deployment conditions)
> コンプライアンス評価の設定になります.<br>
事前にAzure policyによる対象のスコープに、ポリシーかイニシアティブ(ASC Defaultなど)の割り当てが必要です。

![6](./images/6.png)

![7](./images/7.png)


