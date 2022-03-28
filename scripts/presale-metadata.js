const fs = require("fs");

async function main() {
    for(i = 1; i <= 300; i ++) {
        const metadata = {
            name: "FUR Presale NFT #" + i,
            description: "This NFT is redeemable for 500 $FUR tokens and 2 $FURNFT tokens",
            image: "ipfs://QmPNvrwCRTGaqLLX4mapo4dyE6FJQCnStQzZy3rFweqM7B"
        }
        const jsonString = JSON.stringify(metadata);
        fs.writeFileSync("./public/metadata/presale/" + i, jsonString);
        console.log("Write file", i);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
