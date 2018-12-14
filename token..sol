pragma solidity >=0.4.0 <0.6.0;

    contract owned {
        address public owner;
        

        constructor() public {
            owner = msg.sender;
        }

        modifier onlyOwner {
            require(msg.sender == owner);
            _;
        }

        function transferOwnership(address newOwner) onlyOwner public {
            owner = newOwner;
        }
        
       
    }

    contract MyToken is owned {
        
        string public name;
        string public symbol;
        uint8 public decimals;
        uint256 public totalSupply;
        
        mapping (address => uint256) public balanceOf;
        mapping (address => bool) public frozenAccount;
        
        event Transfer(address indexed from, address indexed to, uint256 value);
        event FrozenFunds(address target, bool frozen);
        
        /* Send coins */
        function transfer(address _to, uint256 _value) public {
           require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]); 
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            require(!frozenAccount[msg.sender]);
        }   
        
       constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits) public {
            totalSupply = initialSupply;
            balanceOf[msg.sender] = initialSupply;              
            name = tokenName;                                   
            symbol = tokenSymbol;                               
            decimals = decimalUnits; 
            
        }
        
        function _transfer(address _from, address _to, uint _value) internal {
            require (_to != address(0x0));                          
            require (balanceOf[_from] >= _value);                  
            require (balanceOf[_to] + _value >= balanceOf[_to]);    
            balanceOf[_from] -= _value;                        
            balanceOf[_to] += _value;                        
            emit Transfer(_from, _to, _value);
        }
        
        function mintToken(address target, uint256 mintedAmount) onlyOwner public {
            balanceOf[target] += mintedAmount;
            totalSupply += mintedAmount;
            emit Transfer(owner, target, mintedAmount);
        }
        
        function freezeAccount(address target, bool freeze) onlyOwner public {
            frozenAccount[target] = freeze;
            emit FrozenFunds(target, freeze);
        }
    }
