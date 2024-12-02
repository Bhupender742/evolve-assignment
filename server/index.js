const express = require('express');
const data = require('./db.json');

const app = express();
const PORT = 8000;
const path = require('path');

app.use(express.json());

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '/index.html'));
});

// Routes
app.get('/filters', (req, res) => {
    return res.status(200).json({
        message: 'Filters Fetched Successfully!',
        filters: data.flatMap(json => json.problem_filter)
    });
});

app.post('/items/', (req, res) => {
    const page = req.body.page;
    const keyword = req.body.keyword;
    const filters = req.body.filters;

    if (typeof page == 'undefined') {
        return res.status(400).json({
            message: 'Page param Required!',
        });
    }

    var items = data.flatMap(json => json.data);

    if (typeof filters != 'undefined') {
        let filterNames = filters.split(',');
        items = items.filter(item =>
            filterNames.every(filter => item.problems.includes(filter))
        );
    }

    if (typeof keyword != 'undefined') {
        items = items.filter(item =>
            item.title.toLowerCase().includes(keyword.toLowerCase())
        );
    }

    const result = [];
    let start = page * 10;

    for (let i = start; i < items.length && i < start + 10; i++) {
        result.push(items[i]);
    }

    return res.status(200).json({
        message: 'Items Fetched Successfully!',
        items: result
    })
});

app.listen(PORT , () => console.log(`Server started at http://localhost:${PORT}`));