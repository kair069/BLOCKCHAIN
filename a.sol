// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ContenidoDigital {

    address public creador;
    uint public precioAcceso;
    mapping(address => bool) public accesoConcedido;

    event AccesoConcedido(address indexed consumidor);

    modifier soloCreador() {
        require(msg.sender == creador, "Solo el creador puede realizar esta accion");
        _;
    }


    constructor(uint _precioAcceso) {
        creador = msg.sender;
        precioAcceso = _precioAcceso;
    }

    function adquirirAcceso() external payable {
        require(msg.value == precioAcceso, "El pago no coincide con el precio de acceso");

        accesoConcedido[msg.sender] = true;
        emit AccesoConcedido(msg.sender);
    }

    function interactuar() external view returns (string memory) {
        require(accesoConcedido[msg.sender], "Acceso denegado. Adquiere acceso primero.");
        // Lógica para interactuar con el contenido digital
        return "Interaccion con contenido digital exitosa.";
    }

    function retirarGanancias() external soloCreador {
        payable(creador).transfer(address(this).balance);
    }
}