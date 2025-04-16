return {
    'vlime/vlime',
    ft = {'lisp'},
    config = function()
        vim.opt.rtp:append('vim/')
        vim.cmd([[
            autocmd FileType lisp,vlime setlocal omnifunc=vlime#complete
            autocmd FileType lisp call vlime#plugin#ConnectREPL()
        ]])
    end
}


