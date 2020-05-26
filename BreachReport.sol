pragma solidity >=0.6 <0.7.0;
pragma experimental ABIEncoderV2;

/**
 * @title BreachReport
 * 
*/
contract BreachReport {

    uint breachid;
    
    address private riskAndComplianceUser = 0x7484be8Ce136638aEc2C46f3A5c1d1833CE7B6f9;
    address private ContactCenterUser = 0xEB147eF683E00c881A52eA99aa584B511e23E08D;
    address private AuditorUser = 0x763f74320b6A0f6874499b063a2Ff554ad2418F1;
    bool private stopped = false;

    struct Breach { 
       uint id;
       string state;
       string product;
       string process;
       string control;
       string breachtimestamp;
       string agentName;
       string conversationName;
       string jurisdiction;
       string breachName;
       string regulator;
       string clientDetails;
       string breachDescription;
       string updatedby;
    }
    
    mapping(uint => Breach) internal breaches;
    
    modifier onlyRiskAndComplianceTeam(){
        require(msg.sender == riskAndComplianceUser);
        _;
    }    

    modifier onlyOrg(){
        require(msg.sender == riskAndComplianceUser || msg.sender == ContactCenterUser || msg.sender == AuditorUser );
        _;
    }    

    modifier onlyRegulator(){
        require(msg.sender != riskAndComplianceUser && msg.sender != ContactCenterUser && msg.sender != AuditorUser);
        _;
    }    
    
    modifier isNotStopped {
        require(!stopped, 'Contract is stopped.');
        _;
    }    

    constructor() public {
        breachid = 1;
    }
    

    function toggleContractStopped() onlyRiskAndComplianceTeam public {
      stopped = !stopped;
    }  
    
    function breachInsert(string memory _product,string memory _process,string memory _control,string memory _breachtimestamp,string memory _agentName,string  memory _conversationName,string memory _jurisdiction,string memory _breachName,string memory _regulator,string memory _clientDetails,string memory _breachDescription) public {
        Breach memory breach = Breach(breachid,'INIT',_product,_process,_control,_breachtimestamp,_agentName,_conversationName,_jurisdiction,_breachName,_regulator,_clientDetails,_breachDescription,'SYSTEM');
        breaches[breachid] = breach;
        breachid +=1;
    }     
    
    function breachUpdate(uint256 _id,string memory _product,string memory _process,string memory _control,string memory _breachtimestamp,string memory _agentName,string  memory _conversationName,string memory _jurisdiction,string memory _breachName,string memory _regulator,string memory _clientDetails,string memory _breachDescription,string memory _updatedby) public {
     //   Breach memory breach = Breach(_id,'INPROCESS',_product,_process,_control,_breachtimestamp,_agentName,_conversationName,_jurisdiction,_breachName,_regulator,_clientDetails,_breachDescription);
        if(breaches[_id].id > 0) {
            breaches[_id].state = 'INPROCESS';
            breaches[_id].product = _product;
            breaches[_id].process = _process;
            breaches[_id].control = _control;
            breaches[_id].breachtimestamp = _breachtimestamp;
            breaches[_id].agentName = _agentName;
            breaches[_id].conversationName = _conversationName;
            breaches[_id].jurisdiction = _jurisdiction;
            breaches[_id].breachName = _breachName;
            breaches[_id].regulator = _regulator;
            breaches[_id].clientDetails = _clientDetails;
            breaches[_id].breachDescription = _breachDescription;
            breaches[_id].updatedby = _updatedby;
        }
    }  
    
    function invalidateBreach(uint256 _id) public {
        if(breaches[_id].id > 0) {
            breaches[_id].state = 'INVALID';
        }
    }
    
    function riskAndComplianceTeamSignOff(uint256 _id) public {
    //    Breach memory breach = Breach(_id,_state,_product,_process,_control,_breachtimestamp,_agentName,_conversationName,_jurisdiction,_breachName,_regulator,_clientDetails,_breachDescription);
        if(breaches[_id].id > 0) {
            breaches[_id].state = 'RCTSIGNOFF';
        }
    }  

    function auditorSignOff(uint256 _id) public {
    //    Breach memory breach = Breach(_id,_state,_product,_process,_control,_breachtimestamp,_agentName,_conversationName,_jurisdiction,_breachName,_regulator,_clientDetails,_breachDescription);
        if(breaches[_id].id > 0) {
            breaches[_id].state = 'AUDITSIGNOFF';
        }
    }  

    function regulatorAck(uint256 _id) public {
    //    Breach memory breach = Breach(_id,_state,_product,_process,_control,_breachtimestamp,_agentName,_conversationName,_jurisdiction,_breachName,_regulator,_clientDetails,_breachDescription);
        if(breaches[_id].id > 0) {
            breaches[_id].state = 'REGACK';
        }
    }  

      function getBreaches() public view returns (uint[] memory breachId,string[] memory state,string[] memory control,string[] memory product,string[] memory process,string[] memory breachtimestamp,string[] memory breachName,string[] memory agentName){
          uint[] memory _id = new uint[](breachid-1);
          string[] memory _state = new string[](breachid-1);
          string[] memory _control = new string[](breachid-1);
          string[] memory _product = new string[](breachid-1);
          string[] memory _process = new string[](breachid-1);
          string[] memory _breachtimestamp = new string[](breachid-1);
          string[] memory _breachName = new string[](breachid-1);
          string[] memory _agentName = new string[](breachid-1);


          uint j=0;
          for (uint i = breachid-1; i > 0; i--) {
              if(breaches[i].id > 0){
                _id[j] = breaches[i].id;  
                _state[j] = breaches[i].state;
                _control[j] = breaches[i].control;
                _product[j] = breaches[i].product;
                _process[j] = breaches[i].process;
                _breachtimestamp[j] = breaches[i].breachtimestamp;
                _breachName[j] = breaches[i].breachName;
                _agentName[j] = breaches[i].agentName;
                j +=1;
              }
          }
          return (_id,_state,_control,_product,_process,_breachtimestamp,_breachName,_agentName);
      }
     

      function getBreachesForRegulators() public view returns (uint[] memory breachId,string[] memory state,string[] memory control,string[] memory product,string[] memory process,string[] memory breachtimestamp,string[] memory breachName,string[] memory agentName){
          uint[] memory _id = new uint[](breachid-1);
          string[] memory _state = new string[](breachid-1);
          string[] memory _control = new string[](breachid-1);
          string[] memory _product = new string[](breachid-1);
          string[] memory _process = new string[](breachid-1);
          string[] memory _breachtimestamp = new string[](breachid-1);
          string[] memory _breachName = new string[](breachid-1);
          string[] memory _agentName = new string[](breachid-1);


          uint j=0;
          for (uint i = breachid-1; i > 0; i--) {
              if(breaches[i].id > 0){
                _id[j] = breaches[i].id;  
                _state[j] = breaches[i].state;
                _control[j] = breaches[i].control;
                _product[j] = breaches[i].product;
                _process[j] = breaches[i].process;
                _breachtimestamp[j] = breaches[i].breachtimestamp;
                _breachName[j] = breaches[i].breachName;
                _agentName[j] = breaches[i].agentName;
                j +=1;
              }
          }
          return (_id,_state,_control,_product,_process,_breachtimestamp,_breachName,_agentName);
      }

    function getBreach(uint _id) public view returns (uint breachId,string memory state,string memory control,string memory product,string memory process,string memory breachtimestamp,string memory breachName,string memory breachDescription,string memory conversationName,string memory jurisdiction,string memory regulator,string memory agentName,string memory clientDetails,string memory updatedby){
      if( breaches[_id].id > 0) {

            return (breaches[_id].id,breaches[_id].state,breaches[_id].control,breaches[_id].product,breaches[_id].process,breaches[_id].breachtimestamp,breaches[_id].breachName,breaches[_id].breachDescription,breaches[_id].conversationName,breaches[_id].jurisdiction,breaches[_id].regulator,breaches[_id].agentName,breaches[_id].clientDetails,breaches[_id].updatedby);
      }else{
          return (0,"","","","","","","","","","","","","");
      }
     }
}
