    pragma solidity >=0.4.24 <0.6.0;
    /**
     * @title report4
     * @dev Read and write values to the chain
     */
    contract report4 {
        uint public storedData;
        address owner = 0x7484be8Ce136638aEc2C46f3A5c1d1833CE7B6f9;
        modifier onlyOwner(){
            require(msg.sender == owner);
            _;
        }
        /**
         * @dev Constructor sets the default value
         * @param initVal The initial value
         */
        constructor(uint initVal) public onlyOwner{
            owner = msg.sender;
            storedData = 100;
            storedData = initVal;
        }
        /**
         * @dev Set the value
         * @param x The new value
         */
        function set(uint x) public onlyOwner{
            storedData = x;
        }
        /**
         * @dev Get the value
         */
        function get() public view returns (uint retVal) {
            return storedData;
        }
    }
