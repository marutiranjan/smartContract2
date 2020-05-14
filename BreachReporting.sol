pragma solidity >=0.6 <0.7.0;
pragma experimental ABIEncoderV2;

/**
 * @title Storage
 * @dev Store & retreive value in a variable
 */
contract BreachReporting {

    uint breachid;
    address riskAndComplianceUser = 0x7484be8Ce136638aEc2C46f3A5c1d1833CE7B6f9;
    address ContactCenterUser = 0xEB147eF683E00c881A52eA99aa584B511e23E08D;
    address AuditorUser = 0x763f74320b6A0f6874499b063a2Ff554ad2418F1;
    
    struct Breach { 
       uint256 id;
       string state;
       string control;
       string product;
       string process;
       string obligation;
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

    constructor() public onlyRiskAndComplianceTeam{
        breachid = 1;
    }
    

  //return Array of structure
  function getBreaches() public onlyOrg view returns (Breach[] memory){
      Breach[] memory list = new Breach[](breachid-1);
      uint j=0;
      for (uint i = 1; i < breachid; i++) {
          if(breaches[i].id != 0){
            Breach storage breach = breaches[i];
            list[j] = breach;
            j +=1;
          }
      }
      return list;
  }    
  
  function BreachesForRegulators() public onlyRegulator view returns (Breach[] memory){
      Breach[] memory list = new Breach[](breachid);
      uint j=0;
      for (uint i = 1; i < breachid; i++) {
          if(breaches[i].id != 0 && keccak256(bytes(breaches[i].state)) == keccak256(bytes("auditorsignoff"))){
            Breach storage breach = breaches[i];
            list[j] = breach;
            j +=1;
          }
      }
      return list;
  }  
    
    function breachUpdate(uint id,string memory _state,string memory _control,string memory _product,string memory _process,string memory _obligation) public onlyRiskAndComplianceTeam{
        Breach memory breach = Breach(id,_state,_control,_product,_process,_obligation);
        if(breaches[id].id != 0) {
            breaches[id] = breach;
        }
    }    
    
    function breachUpdateAck(uint id,string memory _state,string memory _control,string memory _product,string memory _process,string memory _obligation) public onlyRegulator{
        Breach memory breach = Breach(id,_state,_control,_product,_process,_obligation);
        if(breaches[id].id != 0) {
            breaches[id] = breach;
        }
    }    
    
    function breachInsert(string memory _control,string memory _product,string memory _process,string memory _obligation) public onlyRiskAndComplianceTeam{
        Breach memory breach = Breach(breachid,'initialized',_control,_product,_process,_obligation);
        breaches[breachid] = breach;
        breachid +=1;

    }   
    
   function getBreach(uint _id) public view returns (uint id, string memory state, string memory control,string memory product, string memory process, string memory obligation){
      Breach memory breach = breaches[_id];    
      return (breach.id,breach.state,breach.control,breach.product,breach.process,breach.obligation);
  }  
}
