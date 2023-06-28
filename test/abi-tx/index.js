require("dotenv").config();
const { ethers } = require("ethers");

const contactABI = [
  {
    inputs: [],
    name: "dec",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "inc",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "count",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "get",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const provider = new ethers.providers.AlchemyProvider(
  "goerli",
  "v3nPXR-U2gLla_XyLUf53LbH4DlUnAnL"
);

// contract add, abi, signerOr Provider
async function main() {
  console.log("hello");
  try {
    const counterContract = new ethers.Contract(
      "0xa7a3C61a5e475b756f65E267C0B2F4A74Dc42d91",
      contactABI,
      provider
    );
    const currentCounterValue = await counterContract.get();
    console.log(currentCounterValue);
  } catch (error) {
    console.log(error);
  }
}

main();
