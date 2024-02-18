pragma solidity ^0.8.0;

contract YourToken {
    struct TokenHolder {
        address holderAddress;
        uint256 balance;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TokenMinted(address indexed to, uint256 value);
    event TokensBurned(address indexed from, uint256 value);
    event TokenSold(address indexed from, address indexed to, uint256 value);

    address public owner;
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    uint256 public tokenPrice;

    constructor() {
        owner = msg.sender;
        tokenPrice = 1 ether; 
    }

    function mintTokens(address _to, uint256 _value) external {
        require(msg.sender == owner, "Only owner can mint tokens");
        require(_to != address(0), "Invalid recipient address");

        balances[_to] += _value;
        totalSupply += _value;

        emit TokenMinted(_to, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        
        balances[msg.sender] -= _value;
        totalSupply -= _value;

        emit TokensBurned(msg.sender, _value);
    }

    function sellTokens(address _to, uint256 _value) external payable {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        require(msg.value == _value * tokenPrice, "Incorrect Ether value");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        payable(msg.sender).transfer(msg.value);

        emit TokenSold(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        // Transfer logic here

        emit Transfer(_from, _to, _value);
        return true;
    }


}
