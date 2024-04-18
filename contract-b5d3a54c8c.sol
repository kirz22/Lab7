// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract UnnTK {
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    string public name = "UnknownTK2";
    uint8 public decimals = 8;
    string public symbol = "UnnTK";
    uint256 public totalSupply = 1000000 * (10 ** uint256(decimals));
    address public owner = msg.sender;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 _allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && _allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (_allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function mint(address _to, uint256 _value) external {
        require(msg.sender == owner, "Only the contract owner can mint tokens");
        require(totalSupply + _value <= 1000000 * (10 ** uint256(decimals)), "Maximum supply exceeded");
        require(totalSupply + _value >= totalSupply);
        totalSupply += _value;
        balances[_to] += _value;
        _value = _value * (10 ** uint256(decimals));
        emit Transfer(address(0), _to, _value);
        }
}