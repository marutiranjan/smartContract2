pragma solidity >=0.4.22 <0.7.0;

/**
 * @title BreachReportPoc
 * @dev Store & retreive value in a variable
 */
contract BreachReportPoc {

    uint breachid;
    address riskAndComplianceUser = 0x7484be8Ce136638aEc2C46f3A5c1d1833CE7B6f9;
    address ContactCenterUser = 0xEB147eF683E00c881A52eA99aa584B511e23E08D;
    address AuditorUser = 0x763f74320b6A0f6874499b063a2Ff554ad2418F1;
    
    uint externalorg;
    

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
        externalorg = 200;
    }
    
    function set(uint _breachid,uint _externalorg) public onlyRiskAndComplianceTeam{
        breachid = _breachid;
        externalorg = _externalorg;
    }
        /**
         * @dev Get the value
         */
    function get() public onlyOrg view returns (uint retVal)  {
        return breachid;
        
    }
    
    function getbreachForRegulator() public onlyRegulator view returns (uint retVal)  {
        return externalorg;
    }    
}


