const fs = require('fs');

fs.readFile('./_table_states_markets.json', 'utf8', (err, data) => {

    if (err) {
        console.log(`Error reading file from disk: ${err}`);
    } else {

        // parse JSON string to JSON object
        const databases = JSON.parse(data);

        // print all databases
        var newData = databases.map((db, index) => {
            return {
                ...db,
                id: index
            }
            
        });
        // const saveData = JSON.stringify(newData);
        // fs.writeFile('./_new_table_states_markets.json', saveData, 'utf8', (err) => {

        //     if (err) {
        //         console.log(`Error writing file: ${err}`);
        //     } else {
        //         console.log(`File is written successfully!`);
        //     }
        
        // });
    }

});