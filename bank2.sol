pragma solidity 0.7.5;

import "./destroyable.sol";


contract Bank is Destroyable {
    
    mapping(address => uint) balance;

    event depositDone(uint amount, address indexed depositedTo); // max 3 parameters per event can be indexed
    event transferComplete(address from, address to, uint amount);
    
    
    function deposit() public payable returns (uint)  {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }
    
    function withdraw(uint amount) public onlyOwner returns (uint) {
        require(balance[msg.sender] >= amount, "insufficient balance");
        // can send money to any address like this
        // address payable toSend = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
        // toSend.transfer(amount); but
        // msg.sender is also an address that is already payable
        balance[msg.sender] -= amount;
        msg.sender.transfer(amount);
        return balance[msg.sender];
    }
    
    function transfer (address recipient, uint amount) public {
        require(balance[msg.sender] >= amount, "insufficient balance");
        require(msg.sender != recipient, "You can't transfer money to yourself");
        
        uint previousSenderBalance = balance[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        assert(balance[msg.sender] == previousSenderBalance - amount);
        
        emit transferComplete(msg.sender, recipient, amount);
    }
    
    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }

    
}