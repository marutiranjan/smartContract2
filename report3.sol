    pragma solidity >=0.4.24 <0.6.0;
    /**
     * @title report3
     * @dev Read and write values to the chain
     */
    contract report3 {
        uint public storedData;
        address owner;
        modifier onlyOwner(){
            require(msg.sender == owner);
            _;
        }
        /**
         * @dev Constructor sets the default value
         * @param initVal The initial value
         */
        constructor(uint initVal) public {
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
