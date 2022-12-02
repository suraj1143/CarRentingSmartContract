//SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract alpha is ERC20{
    event amntReceived (address indexed _from, uint amount);
    event tokenSent(address indexed to,uint amount);
    receive() external payable{
        emit amntReceived(msg.sender, msg.value/1 ether);
        // Bob(value);
    }
    address public immutable OWNER;
    constructor() ERC20("ALPHA", "ALP") {
        _mint(msg.sender,1000);
        OWNER= msg.sender;
    }

    // function tokenExchange(address to, uint256 amount) public{
    //     _transfer(OWNER, to, amount);
    // }
     function Bob() public payable{
        uint value = (msg.value/1 ether);
        _transfer(OWNER, msg.sender, value*10);
        emit tokenSent(msg.sender, value*10);
    }
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }


}