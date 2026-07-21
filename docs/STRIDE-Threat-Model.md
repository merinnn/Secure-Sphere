# Secure-Sphere STRIDE Threat Model

| Threat | Risk Scenario | Architectural Mitigation |
| :--- | :--- | :--- |
| **Spoofing** | Attacker steals admin session tokens to access management APIs | FIDO2 Hardware MFA + Short-lived JIT access via PAM Vault |
| **Tampering** | Rogue actor attempts to modify bank transaction logs | WORM (Write Once Read Many) append-only database audit logs |
| **Repudiation** | User denies making a wire transfer | Cryptographic payload signing (HMAC-SHA256) per transaction |
| **Information Disclosure** | Database backup exposed in cloud storage | AES-256 KMS encryption + Dynamic Data Masking |
| **Denial of Service** | L7 HTTP flood crashes application gateway | Cloudflare Anycast DDoS protection + API Rate Limiting |
| **Elevation of Privilege**| Compromised web container attempts lateral move to DB | Microsegmentation via Security Groups restricting port 5432 |