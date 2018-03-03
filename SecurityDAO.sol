pragma solidity ^0.4.11;

contract StakePool
{
    function getWeight(address _staker) constant returns (uint256);
    function totalVotingWeight() constant returns (uint256);
}

contract SecurityDAO {

  struct auditor {
    address addr;
    string  github_profile; // link
    string  email_address;  // email
    uint256 karma;
    uint256 error_coefficient;
    bool    manager;
  }
  
  struct election {
      address addr;
      uint256 votes_for;
      uint256 votes_against;
      uint256 start_date;
      uint256 end_date;
      bool    active;
  }
  
  struct report {
      string    gist_link;  // Assigned by creator. 
      string    gist_hash;  // Assigned by creator. 
      address   author;     // Assigned by creator. 
      
      uint256   timestamp;  // Assigned automatically.
      bool      revealed;   // Assigned automatically.
      
      uint256   errors;           // Assigned by manager. 
      uint256   bytecode_length;  // Assigned by manager. 
      address[] signers;          // Assigned by manager.
  }
  
  mapping (address => auditor)  public auditors;
  mapping (address => election) public elections;
  mapping (uint256 => report)   public reports;
  
  uint256 public total_reports;
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
      auditors[msg.sender].addr              = msg.sender;
      auditors[msg.sender].github_profile    = _github;
      auditors[msg.sender].email_address     = _email;
      auditors[msg.sender].error_coefficient = 2;
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
  
  function submit_report(string _gist_hash)
  {
      // Submit a private report.
      require(msg.sender == auditors[msg.sender].addr);
      
      reports[total_reports].gist_hash = _gist_hash;
      reports[total_reports].timestamp = now;
      reports[total_reports].author    = msg.sender;
      total_reports++;
  }
  
  function sign_report(string _gist_hash, uint256 _errors, uint256 _bytecode_length, uint256 _report_id)
  {
      // Sign private report before revealing.
      require(auditors[msg.sender].manager);
      require(!reports[_report_id].revealed); // TODO: implement signing an already-existing reports by multiple managers
      
      reports[_report_id].errors = _errors;
      reports[_report_id].bytecode_length = _bytecode_length;
      reports[_report_id].signers.push(msg.sender);
  }
  
  function reveal_report(string _gist_hash, string _gist_link, uint256 _report_id)
  {
      // NOTE: manager that knows the gist link can reveal it.
      // Report author can reveal his own report as well.
      require(!reports[_report_id].revealed);
      require(sha256(sha256(_gist_link)) == sha256(_gist_hash)); // TODO: explicit type conversions not allowed. Refactor this.
  
      reports[_report_id].gist_link = _gist_link;
      auditors[reports[_report_id].author].error_coefficient += reports[_report_id].errors;
      auditors[reports[_report_id].author].karma += reports[_report_id].bytecode_length;
  }
  
  function getKarma(address _auditor) constant returns (uint256)
  {
      return ( auditors[_auditor].karma / auditors[_auditor].error_coefficient );
  }
  

// TODO: rollback actions of malitious managers through voting.
// TODO: debugging functions.
// TODO: payment autodistribution.
}
