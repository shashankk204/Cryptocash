// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShankyCoin{
    
    string public name="Shanky Coin";
    string public symbol="SKC";
    string public standard="@shankycoin v.0.1";
    uint256 public totalSupply;
    address public ownerOfContract;
    uint256 public nonce;
    address[] public holderToken;
    
    constructor(uint256 _initialSupply)
    {
        ownerOfContract=msg.sender;
        balanceOf[msg.sender]=_initialSupply;
        totalSupply=_initialSupply;
    }



    struct TokenHolderInfo {
        uint256 _tokenId;
        address _from;
        address _to;
        uint256 _totalToken;
        bool _tokenHolder; 
    }


    event Transfer(address indexed _from,address indexed _to , uint256 _value);
    event Approval(address indexed _owner,address indexed _spender,uint256 _value);

    mapping (address => TokenHolderInfo) public tokenHolderInfos;
    mapping(address=>uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
   


    //helper Func
    function inc() internal{
        nonce++;    
    }

    function transfer(address _to,uint256 _value) public returns(bool success)
    {
        require(balanceOf[msg.sender]>=_value);
        inc();
        balanceOf[msg.sender]-=_value;
        balanceOf[_to]+=_value;
        TokenHolderInfo storage tokenHolderInfo=tokenHolderInfos[_to];
        tokenHolderInfo._tokenId=nonce;
        tokenHolderInfo._from=msg.sender;
        tokenHolderInfo._to=_to;
        tokenHolderInfo._tokenHolder=true;

        holderToken.push(_to);
        emit Transfer(msg.sender,_to,_value);
        return true;
    }
    function transferFrom(address _from, address _to,uint256 _value) public returns(bool success){
        require(_value <= balanceOf[_from]);
        require(_value <=allowance[_from][msg.sender]);

        balanceOf[_from] -=_value;
        allowance[_from][msg.sender]-=_value;
        balanceOf[_to] +=_value;
        emit Transfer(_from,_to,_value);
        return true;


    }

    function getTokenHolderData(address _address) public view returns(uint256,address,address,uint256,bool)
    {
        return(tokenHolderInfos[_address]._tokenId,
        tokenHolderInfos[_address]._to,
        tokenHolderInfos[_address]._from,
        tokenHolderInfos[_address]._totalToken,
        tokenHolderInfos[_address]._tokenHolder);
    }
    function getTokenHolder() public view returns(address[] memory)
    {
        return holderToken;
    }
    


}