# Ethereum Commonwealth smart-contract audit DAO.

NOTE: This is the very first implementation. It requires more testing/debugging before use. Ethereum Commonwealth will use this contract as a public registry of smart-contract audits. Decentralized governance of the security-auditing organization will only make sense after the *second planned hardfork of Callisto Network* (11 Nov, 2019)

Solidity smart-contract source code: [SecurityDAO.sol](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol)

The following describes a structure and workflow of Ethereum Commonwealth ETC & CLO smart-contract auditing department. ( read [Callisto whitepaper](https://drive.google.com/file/d/16sW_0YajCedBdLvr9jmgJqE9L-SzuYKq/view) for more information )

# Abstract

Smart-contract security is critical for most blockchain DApp development platforms. The main goal of this organization is to improve the security of Ethereum Classic and Callisto ecosystem by providing free security audits for smart-contract developers.

We do not rely on blockchain technology to verify smart-contracts. We only use it to provide a registry of audited contracts, publish and manage **results** of smart-contract audits.

It should be noted that smart-contract auditing organization is scalable which means that it allows to hire, manage and pay security audits of any smart-contracts written in any language depending on demand.

# Structure

![alt text](https://github.com/Dexaran/Security-DAO-registry/blob/master/Audit_Reg_Flow.png)

There are two types of participants in the described organization: [managers](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L17) and [auditors](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L11-L18).

The main task of a manager is to control and verify the work of the auditors.

The main task of an auditor is to review a code of smart-contracts and submit [reports](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L29-L40). Auditors receive [karma](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L15) for reviewing contracts. They also receive [penalties](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L16) for making mistakes. The statistic reflects each auditors results and determines their reward.

Both, managers and auditors are paid from Callisto treasury.

The audit process will be managed through github so that it will be transparently available for everyone. A smart-contract developer should open an [issue](https://github.com/Dexaran/Security-DAO/issues) to submit his smart-contract for auditors review. Then the manager will verify security audit request details and mark the issue as *approved*. The manager should not mark dummy requests, requests that aim to spam the security audit queue or any requests that does not met coding standard requirements. After that, **every** auditor can start reviewing the code. 

An auditor with a willingness to participate in the code review of a certain contract must create a [private gist](https://gist.github.com/) and send gist URL to the corresponding issue manager by [email](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L14). E-mail address of each manager or auditor is transparently available at the smart-contract of this organization.

# Rewards

**Managers** are always paid regardless of their activity, but they are controlled by Cold Stakers voting (or security department owner manual control during the debugging stage). Average community member can not know details and specifics of security auditing process, thus Cold Stakers can not verify or control the activity of security auditors. This is the purpose of security audit organization managers. We rely on an assumption that average community member can verify managers activity and determine whether a manager is a malicious actor or not. 

If it was noticed that the manager does not act as he should or does not work for significant amount of time without any explanation, then he must be dismissed via the Cold Stakers voting (or security department owner manual control during the debugging stage) and another manager must be elected.

**Auditors** are paid depending on their activity summary. An auditor is marked as `active` when he is submitting a report. After a certain amount of time (yet under consideration) the `active` status is removed. Top active auditors with the highest amount of "karma" are paid depending on budget.

*Example:*

We have 10 auditors with the corresponding "karma" amount:

1. Alice (14788)

2. Bob (12000)

3. Carol (11700)

4. Dex (11699)

5. Elon (11400)

6. Fabian (11300)

7. Gabriele (7304)

8. HODLer (7200)

9. Iggy (3323)

10. Jack (200)

Callisto treasury allocates **3000 CLO**/month for auditing department payments for example. Assume security auditor salary **$10,000**/month and 1 CLO = $10. With such parameters we will have top-3 auditors paid: Alice, Bob and Carol.

Let's pretend that the ecosystem has grown. The amount of smart-contract developers has grown as well alongside with CLO price. At 1 CLO = $20 we will have 20 * 3000 = $60,000/month which allows to pay 6 security auditors now: Alice, Bob, Carol, Dex, Elon, Fabian.

NOTE: The described model allows an auditor to leave at any time. For example, if Alice will be on vocation for 1 month, then she will not be marked as `active` during this month and only top-6 active auditors will receive salaries: Bob, Carol, Dex, Elon, Fabian, Gabriele.

It should be noted that even a beginner is incentivised to submit audit reports and review the codes for the sake of karma.

We must keep in mind that smart contract systems can be of different complexity. As the result, it is decided to use the **length of a bytecode of audited smart-contracts compiled with `0.4.20+commit.3155dd80` compiler without optimization** as a measure of contract complexity and auditors karma coeffitient calculations.

## Step by step interaction with auditing registry

- A smart-contract developer submits an [audit request issue](https://github.com/Dexaran/Security-DAO-registry/issues).

- Auditing organization manager verifies the auditing request and sets an `approved` label.

- Auditors are picking the issue. In most cases 3 code reviewers is a sufficient number. In case of smart-contract systems of high complexity it may require more code reviewers.

- A manager replaces `approved` label with `in-progress` label. After that, the issue is still available for picking but submitting audit reports for this issue will not affect the "active" status of an auditor. Thus, reviewing the contract code will still make sense for beginners for the sake of "karma" increase and earning experience but we can avoid a situation when the whole team is working on a single contract with other audit requests being in pending.

- Auditor is creating a private gist. Then he submits a Keccak-256 hash of gist link to the contract by the [submit_report](https://github.com/Dexaran/Security-DAO-registry/blob/master/SecurityDAO.sol#L106) function. Example: the gist link is `https://gist.github.com/user/1234abc1234abc`. The hash of this gist that needs to be submitted to the contract is `026c43a23ba6a331739fe8d066b9bd1a6eac53982358aa3ff7cb5d0301712d2d`.

- Auditor delivers the private gist link (report) to the manager off-chain. Auditor must not publish the report gist link which is preimage of the gist hash that is submitted to the contract.

- Once the manager has received a link to the private gist, the auditors can start reviewing the code and reporting findings in their private gists.

- Once every auditor finished, a manager must compare reports.

- If one of the auditors has not described the vulnerability that others have identified, then the manager must assign him a penalty, increasing the "errors" property of report.

- Manager [signs](https://github.com/Dexaran/Security-DAO-registry/blob/master/SecurityDAO.sol#L117) reports.

- Manager [reveals](https://github.com/Dexaran/Security-DAO-registry/blob/master/SecurityDAO.sol#L128) reports. Once reports are revealed the gist links are publicly accessible so that everyone can observe the work of managers and auditors.

- At the moment of audit report revealing the report author receives karma bonuses, error penalties and `active` status.
