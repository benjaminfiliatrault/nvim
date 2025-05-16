require("config")

-- [[ Filetype Detection ]]
-- Detect Jenkinsfile as a Groovy Filetype
vim.filetype.add {
    filename = {
        ['Jenkinsfile'] = 'groovy',
        ['jenkinsfile'] = 'groovy',
    },
}

