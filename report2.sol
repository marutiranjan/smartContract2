pragma solidity >=0.4.24 <0.6.0;
    /**
     * @title report2
     * @dev Read and write values to the chain
     */
    contract report2 {
        uint public storedData;
        /**
         * @dev Constructor sets the default value
         * @param initVal The initial value
         */
        constructor(uint initVal) public {
            storedData = initVal;
        }
        /**
         * @dev Set the value
         * @param x The new value
         */
        function set(uint x) private {
            storedData = x;
        }
        /**
         * @dev Get the value
         */
        function get() public view returns (uint retVal) {
            return storedData;
        }
    }
