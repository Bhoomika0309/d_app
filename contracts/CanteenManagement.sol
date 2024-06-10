// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CanteenManagement {
    address public owner;
    mapping(string => uint) public menu;
    mapping(address => mapping(string => uint)) public orders;

    event ItemAdded(string item, uint price);
    event OrderPlaced(address indexed customer, string item, uint quantity);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function addItem(string memory _item, uint _price) public onlyOwner {
        menu[_item] = _price;
        emit ItemAdded(_item, _price);
    }

    function placeOrder(string memory _item, uint _quantity) public payable {
        require(menu[_item] > 0, "Item not available in the menu");
        require(msg.value >= menu[_item] * _quantity, "Insufficient funds");

        orders[msg.sender][_item] += _quantity;
        payable(owner).transfer(msg.value);
        emit OrderPlaced(msg.sender, _item, _quantity);
    }

    function getOrder(
        address _customer,
        string memory _item
    ) public view returns (uint) {
        return orders[_customer][_item];
    }
}
