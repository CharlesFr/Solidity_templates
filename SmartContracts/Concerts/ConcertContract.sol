pragma solidity ^0.4.0;

contract Concert {

    address owner;
    uint public tickets;
    uint constant price = 1 ether;
    
    // mapping stores a list of keys and values
    mapping(address => uint) public purchasers;
    
    function Concert(uint t) {
        owner = msg.sender;
        tickets = t;
    }
    
    function () payable {
        buyTickets(1);
    }
    
    function buyTickets(uint amount) payable {
        if(msg.value != (amount * price) || amount > tickets){
            throw;
        }
        
        purchasers[msg.sender] += amount;
        tickets -= amount;
        
        if(tickets == 0){
            selfdestruct(owner);
        }
    }
    
    function website() returns (string);
    
}

interface Refundable  {
    function refund(uint numTickets) returns (bool);
}

contract MobgenConcert is Concert(10), Refundable {
    
    function refund(uint numTickets) returns(bool){
        if( purchasers[msg.sender] < numTickets){
            return false;
        }
        
        msg.sender.transfer(numTickets * price);
        purchasers[msg.sender] -= numTickets;
        tickets += numTickets;
        return true;
    }
        
    function website() returns (string) {
        return "www.mobgen.com";
    }

}
