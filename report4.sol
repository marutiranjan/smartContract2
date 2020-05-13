    pragma solidity >=0.4.24 <0.6.0;
    /**
     * @title report4
     * @dev Read and write values to the chain
     */
    contract report4 {
        uint public storedData;
        address owner = 0x437683744c89A7a05fF10fD0cd8eE59d02EbC050;
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
