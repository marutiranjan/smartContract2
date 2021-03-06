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
    
    modifier onlyAuditor(){
        require(msg.sender == AuditorUser);
        _;
    }   
    
    modifier onlyRiskTeamAndAuditor(){
        require(msg.sender == riskAndComplianceUser || msg.sender == AuditorUser);
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

    constructor() public onlyRiskAndComplianceTeam {
        breachid = 1;
    }

    function toggleContractStopped() onlyRiskAndComplianceTeam public {
      stopped = !stopped;
    }  

    function breachInsert(string[] memory breachFields,string[] memory breachValues) public onlyRiskAndComplianceTeam isNotStopped {
        Breach memory breach = Breach(breachid,'INIT',breachValues[0],breachValues[1],breachValues[2],breachValues[3],breachValues[4],breachValues[5],breachValues[6],breachValues[7],breachValues[8],breachValues[9],breachValues[10],'SYSTEM');
        breaches[breachid] = breach;
        breachid +=1;
    } 

    function breachUpdate(uint breachid,string[] memory breachFields,string[] memory breachValues) public onlyRiskAndComplianceTeam isNotStopped {
        
        if(breaches[breachid].id == breachid){
            Breach memory breach = Breach(breachid,'ACTIVE',breachValues[0],breachValues[1],breachValues[2],breachValues[3],breachValues[4],breachValues[5],breachValues[6],breachValues[7],breachValues[8],breachValues[9],breachValues[10],'SYSTEM');
            breaches[breachid] = breach;
        }
    } 

    function inActivateBreach(uint256 _id) public onlyRiskTeamAndAuditor isNotStopped {
        if(breaches[_id].id == _id) {
            breaches[_id].state = 'INACTIVE';
        }
    }
    
    function ActivateBreach(uint256 _id) public onlyRiskTeamAndAuditor isNotStopped {
        if(breaches[_id].id == _id) {
            breaches[_id].state = 'ACTIVE';
        }
    }
	
    function riskAndComplianceTeamSignOff(uint256 _id) public onlyRiskAndComplianceTeam isNotStopped {

        if(breaches[_id].id == _id) {
            breaches[_id].state = 'RCTSIGNOFF';
        }
    }  

    function auditorSignOff(uint256 _id) public onlyAuditor isNotStopped {
        if(breaches[_id].id == _id) {
            breaches[_id].state = 'AUDITSIGNOFF';
        }
    }  

    function regulatorAck(uint256 _id) public onlyRegulator isNotStopped {
        if(breaches[_id].id == _id) {
            breaches[_id].state = 'REGACK';
        }
    }  
    
    function getBreachData(uint _id) public onlyOrg isNotStopped view returns (uint breachid,string[] memory breachFields,string[] memory breachValues){
      if( breaches[_id].id == _id) {
          string [] memory _breachFields = new string[](13);
          string [] memory _breachValues = new string[](13);
          _breachFields[0] = 'state';
		  _breachFields[1] = 'product';
		  _breachFields[2] = 'process';
		  _breachFields[3] = 'control';
		  _breachFields[4] = 'breachtimestamp';
		  _breachFields[5] = 'agentName';
		  _breachFields[6] = 'conversationName';
          _breachFields[7] = 'jurisdiction';
		  _breachFields[8] = 'breachName';
		  _breachFields[9] = 'regulator';
		  _breachFields[10] = 'clientDetails';
		  _breachFields[11] = 'breachDescription';
		  _breachFields[12] = 'updatedby';
		  
		  _breachValues[0] = breaches[_id].state;
		  _breachValues[1] = breaches[_id].product;
		  _breachValues[2] = breaches[_id].process;
		  _breachValues[3] = breaches[_id].control;
		  _breachValues[4] = breaches[_id].breachtimestamp;
		  _breachValues[5] = breaches[_id].agentName;
		  _breachValues[6] = breaches[_id].conversationName;
          _breachValues[7] = breaches[_id].jurisdiction;
		  _breachValues[8] = breaches[_id].breachName;
		  _breachValues[9] = breaches[_id].regulator;
		  _breachValues[10] = breaches[_id].clientDetails;
		  _breachValues[11] = breaches[_id].breachDescription;
		  _breachValues[12] = breaches[_id].updatedby;
		  
            return (_id,_breachFields,_breachValues);
      }
     }     

      function getAllBreaches() public onlyOrg isNotStopped view returns (uint[] memory breachId,string[] memory state,string[] memory control,string[] memory product,string[] memory process,string[] memory breachName){
          uint[] memory _id = new uint[](breachid-1);
          string[] memory _state = new string[](breachid-1);
          string[] memory _control = new string[](breachid-1);
          string[] memory _product = new string[](breachid-1);
          string[] memory _process = new string[](breachid-1);
          string[] memory _breachName = new string[](breachid-1);



          uint j=0;
          for (uint i = breachid-1; i > 0; i--) {
              if(breaches[i].id > 0){
                _id[j] = breaches[i].id;  
                _state[j] = breaches[i].state;
                _control[j] = breaches[i].control;
                _product[j] = breaches[i].product;
                _process[j] = breaches[i].process;
                _breachName[j] = breaches[i].breachName;
                j +=1;
              }
          }
          return (_id,_state,_control,_product,_process,_breachName);
      }	 
	  
      function getBreachesInRange(uint startId,uint range) public onlyOrg isNotStopped view returns (uint[] memory breachId,string[] memory state,string[] memory control,string[] memory product,string[] memory process,string[] memory breachName){
          
		  uint[] memory _id = new uint[](range);
          string[] memory _state = new string[](range);
          string[] memory _control = new string[](range);
          string[] memory _product = new string[](range);
          string[] memory _process = new string[](range);
          string[] memory _breachName = new string[](range);
		  
		  uint bid = 0;
          if (startId == 0){
			bid = breachid-1;
		  }else{
		    bid = startId-1;
		  }		  

          uint j=0;
          for (uint i = bid; j < range && i > 0 ; i--) {
              if(breaches[i].id > 0){
                _id[j] = breaches[i].id;  
                _state[j] = breaches[i].state;
                _control[j] = breaches[i].control;
                _product[j] = breaches[i].product;
                _process[j] = breaches[i].process;
                _breachName[j] = breaches[i].breachName;
                j +=1;
              }
          }
          return (_id,_state,_control,_product,_process,_breachName);
      }	
	  
    function getBreachDataForRegulator(uint _id) public onlyRegulator isNotStopped view returns (uint breachid,string[] memory breachFields,string[] memory breachValues){
      if( breaches[_id].id == _id && ( ((keccak256(bytes(breaches[_id].state)) == keccak256(bytes("AUDITSIGNOFF")))) ||  ((keccak256(bytes(breaches[_id].state)) == keccak256(bytes("REGACK")))) ) ) {
          string [] memory _breachFields = new string[](13);
          string [] memory _breachValues = new string[](13);
          _breachFields[0] = 'state';
		  _breachFields[1] = 'product';
		  _breachFields[2] = 'process';
		  _breachFields[3] = 'control';
		  _breachFields[4] = 'breachtimestamp';
		  _breachFields[5] = 'agentName';
		  _breachFields[6] = 'conversationName';
          _breachFields[7] = 'jurisdiction';
		  _breachFields[8] = 'breachName';
		  _breachFields[9] = 'regulator';
		  _breachFields[10] = 'clientDetails';
		  _breachFields[11] = 'breachDescription';
		  _breachFields[12] = 'updatedby';
		  
		  _breachValues[0] = breaches[_id].state;
		  _breachValues[1] = breaches[_id].product;
		  _breachValues[2] = breaches[_id].process;
		  _breachValues[3] = breaches[_id].control;
		  _breachValues[4] = breaches[_id].breachtimestamp;
		  _breachValues[5] = breaches[_id].agentName;
		  _breachValues[6] = breaches[_id].conversationName;
          _breachValues[7] = breaches[_id].jurisdiction;
		  _breachValues[8] = breaches[_id].breachName;
		  _breachValues[9] = breaches[_id].regulator;
		  _breachValues[10] = breaches[_id].clientDetails;
		  _breachValues[11] = breaches[_id].breachDescription;
		  _breachValues[12] = breaches[_id].updatedby;
		  
            return (_id,_breachFields,_breachValues);
      }
     }     

      function getAllBreachesForRegulator() public onlyRegulator isNotStopped view returns (uint[] memory breachId,string[] memory state,string[] memory control,string[] memory product,string[] memory process,string[] memory breachName){
          uint[] memory _id = new uint[](breachid-1);
          string[] memory _state = new string[](breachid-1);
          string[] memory _control = new string[](breachid-1);
          string[] memory _product = new string[](breachid-1);
          string[] memory _process = new string[](breachid-1);
          string[] memory _breachName = new string[](breachid-1);



          uint j=0;
          for (uint i = breachid-1; i > 0; i--) {
              if(breaches[i].id == i && ( ((keccak256(bytes(breaches[i].state)) == keccak256(bytes("AUDITSIGNOFF")))) ||  ((keccak256(bytes(breaches[i].state)) == keccak256(bytes("REGACK")))) )){
                _id[j] = breaches[i].id;  
                _state[j] = breaches[i].state;
                _control[j] = breaches[i].control;
                _product[j] = breaches[i].product;
                _process[j] = breaches[i].process;
                _breachName[j] = breaches[i].breachName;
                j +=1;
              }
          }
          return (_id,_state,_control,_product,_process,_breachName);
      }	 
	  
      function getBreachesInRangeForRegulator(uint startId,uint range) public onlyRegulator isNotStopped view returns (uint[] memory breachId,string[] memory state,string[] memory control,string[] memory product,string[] memory process,string[] memory breachName){
          uint[] memory _id = new uint[](range);
          string[] memory _state = new string[](range);
          string[] memory _control = new string[](range);
          string[] memory _product = new string[](range);
          string[] memory _process = new string[](range);
          string[] memory _breachName = new string[](range);
		  
		  uint bid = 0;
          if (startId == 0){
			bid = breachid-1;
		  }else{
		    bid = startId-1;
		  }		  

          uint j=0;
          for (uint i = bid; j < range && i > 0 ; i--) {
              if(breaches[i].id == i && ( ((keccak256(bytes(breaches[i].state)) == keccak256(bytes("AUDITSIGNOFF")))) ||  ((keccak256(bytes(breaches[i].state)) == keccak256(bytes("REGACK")))) )){
                _id[j] = breaches[i].id;  
                _state[j] = breaches[i].state;
                _control[j] = breaches[i].control;
                _product[j] = breaches[i].product;
                _process[j] = breaches[i].process;
                _breachName[j] = breaches[i].breachName;
                j +=1;
              }
          }
          return (_id,_state,_control,_product,_process,_breachName);
      }	

}
