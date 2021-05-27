pragma solidity 0.7.5;

import "./ownable.sol";

contract Destroyable is Ownable {
    
    function destroyContract() public onlyOwner {
        selfdestruct(owner);
    } 
    
}
