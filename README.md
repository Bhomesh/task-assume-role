# Terraform IAM Roles and Policies

This project sets up AWS IAM roles and policies using Terraform. It includes a restricted role with IP-based access control and an unrestricted role that can assume the restricted role.

## Project Structure

- **main.tf**: Entry point for the Terraform configuration.
- **provider.tf**: AWS provider configuration.
- **variables.tf**: Input variables.
- **outputs.tf**: Output values.
- **policies.tf**: IAM policies.
- **roles.tf**: IAM roles.
- **users.tf**: IAM users.
- **terraform.tfvars**: Contains variable values, such as allowed IP addresses.
- **.gitignore**: Specifies files and directories to be ignored by Git.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your machine.
- AWS account credentials configured locally (e.g., using `aws configure`).

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

5. **Destroy the infrastructure** (when no longer needed):
   ```bash
   terraform destroy
   ```

## Configuration

- **allowed_ip**: Set your allowed IP address in `terraform.tfvars` to restrict access to the restricted role.

## IAM Roles and Policies

- **Restricted Role**: Can only be assumed by the unrestricted role and is restricted by IP.
- **Unrestricted Role**: Can be assumed by any user in the account and can assume the restricted role.

## Security Considerations

- Ensure `terraform.tfvars` is not committed to version control as it may contain sensitive information.
- Use IAM best practices, such as least privilege and enabling MFA.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Contact

For questions or support, please contact [Your Name](mailto:your.email@example.com).