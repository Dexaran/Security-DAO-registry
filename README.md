# Ethereum Commonwealth smart-contract audit DAO.

NOTE: This is the very first implementation. It requires more testing/debugging before use.

The following describes a structure and workflow of Ethereum Commonwealth ETC & CLO smart-contract auditing department. ( read [Callisto whitepaper](https://drive.google.com/file/d/16sW_0YajCedBdLvr9jmgJqE9L-SzuYKq/view) for more information )

## Abstract

Smart-contract security is critical for most blockchain DApp development platforms. The main goal of this organization is to improve the security of Ethereum Classic and Callisto ecosystem by providing free security audits for smart-contract developers.

We do not rely on blockchain technology to verify smart-contracts. We only use it to provide a registry of audited contracts, publish and manage **results** of smart-contract audits.

It should be noted that smart-contract auditing organization is scalable which means that it allows to hire, manage and pay security audits of any smart-contracts written in any language depending on demand.

## Structure

There are two types of participants in the described organization: [managers](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L17) and [auditors](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L11-L18).

The main task of a manager is to control and verify the work of the auditors.

The main task of an auditor is to review a code of smart-contracts and submit [reports](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L29-L40). Auditors receive [karma](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L15) for reviewing contracts. They also receive [penalties](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L16) for making mistakes. The statistic reflects each auditors results and determines their reward.

Both, managers and auditors are paid from Callisto treasury.

The audit process will be managed through github so that it will be transparently available for everyone. A smart-contract developer should open an [issue](https://github.com/Dexaran/Security-DAO/issues) to submit his smart-contract for auditors review. Then the manager will verify security audit request details and mark the issue as *approved*. The manager should not mark dummy requests, requests that aim to spam the security audit queue or any requests that does not met coding standard requirements. After that, **every** auditor can start reviewing the code. 

An auditor with a willingness to participate in the code review of a certain contract must create a [private gist](https://gist.github.com/) and send gist URL to the corresponding issue manager by [email](https://github.com/Dexaran/Security-DAO/blob/master/SecurityDAO.sol#L14). E-mail address of each manager or auditor is transparently available at the smart-contract of this organization.

## Rewards

Managers are always paid regardless of their activity, but they are controlled by Cold Stakers voting (or security department owner manual control during the debugging stage). Average community member can not know details and specifics of security auditing process, thus Cold Stakers can not verify or control the activity of security auditors. This is the purpose of security audit organization managers. We rely on an assumption that average community member can verify managers activity and determine whether a manager is a malicious actor or not. 

If it was noticed that the manager does not act as he should or does not work for significant amount of time without any explanation, then he must be dismissed via the Cold Stakers voting (or security department owner manual control during the debugging stage) and another manager must be elected.
