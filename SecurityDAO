pragma solidity ^0.4.11;

contract StakePool
{
    function getWeight(address _staker) constant returns (uint256);
    function totalVotingWeight() constant returns (uint256);
}

contract SecurityDAO {

  struct auditor {
    address addr;
    string github_profile; // link
    string email_address;  // email
    uint256 karma;
    bool manager;
  }
  
  struct election {
      address addr;
      uint256 votes_for;
      uint256 votes_against;
      uint256 start_date;
      uint256 end_date;
      bool active;
  }
  
  mapping (address => auditor) public auditors;
  mapping (address => election) public elections;
  
  uint256 public election_duration = 25 days;
  address public stake_pool;
  
  function become_manager()
  {
      require( (msg.sender == auditors[msg.sender].addr) && (auditors[msg.sender].manager == false) );
      require(elections[msg.sender].end_date < now);
      require(elections[msg.sender].active = false);
      elections[msg.sender].start_date = block.timestamp;
      elections[msg.sender].end_date   = block.timestamp + election_duration;
      elections[msg.sender].active     = true;
  }
  
  function become_auditor(string _github, string _email)
  {
      require( auditors[msg.sender].addr == 0x00 );
      auditors[msg.sender].addr           = msg.sender;
      auditors[msg.sender].github_profile = _github;
      auditors[msg.sender].email_address  = _email;
  }
  
  function vote_manager(address _who, bool _for)
  {
      require( (elections[_who].active = true) && (elections[msg.sender].end_date < now) );
      if(_for)
      {
          elections[_who].votes_for += StakePool(stake_pool).getWeight(msg.sender);
      }
      else
      {
          elections[_who].votes_against += StakePool(stake_pool).getWeight(msg.sender);
      }
  }
  
  function evaluate_election(address _who)
  {
      require(elections[_who].active = true);
      require(elections[_who].end_date < now);
      if(evaluateElection(_who))
      {
          auditors[_who].manager = true;
      }
      elections[_who].active = false;
  }
  
  function evaluateElection(address _who) private constant returns (bool)
  {
      // Make sure that at least 50% of voters have confirmed their position.
      require( (elections[_who].votes_for + elections[_who].votes_against) > StakePool(stake_pool).totalVotingWeight() / 2 );
      if(elections[_who].votes_for > elections[_who].votes_against)
      {
          return true;
      }
      return false;
      
  }
}
