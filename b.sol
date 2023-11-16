// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public proyecto;
    address public administrador;
    uint public objetivoFinanciamiento;
    uint public fondosActuales;
    mapping(address => uint) public contribuciones;

    event FinanciamientoAlcanzado(address indexed contribuyente, uint monto);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "Solo el administrador puede realizar esta accion");
        _;
    }

    constructor(uint _objetivoFinanciamiento) {
        proyecto = address(this);
        administrador = msg.sender;
        objetivoFinanciamiento = _objetivoFinanciamiento;
    }

    function contribuir() external payable {
        require(msg.value > 0, "La contribucion debe ser mayor a cero");
        require(fondosActuales + msg.value <= objetivoFinanciamiento, "Objetivo de financiamiento alcanzado");

        contribuciones[msg.sender] += msg.value;
        fondosActuales += msg.value;

        if (fondosActuales >= objetivoFinanciamiento) {
            emit FinanciamientoAlcanzado(msg.sender, fondosActuales);
        }
    }

    function retirarFondos() external soloAdministrador {
        require(fondosActuales >= objetivoFinanciamiento, "El objetivo de financiamiento no ha sido alcanzado");
        payable(proyecto).transfer(fondosActuales);
        fondosActuales = 0;
    }
}