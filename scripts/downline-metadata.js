const fs = require("fs");

async function main() {
    for(i = 1; i <= 10000; i ++) {
        const metadata = {
            name: "FUR NFT #" + i,
            description: "This NFT is used for Furio downline rewards and future voting rights.",
            image: "ipfs://QmdDQ3F8jhFRkwbjVMfH583Tiaaf53hkL1atviav9wd3nY"
        }
        const jsonString = JSON.stringify(metadata);
        fs.writeFileSync("./public/metadata/downline-g1/" + i, jsonString);
        console.log("Write file", i);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
