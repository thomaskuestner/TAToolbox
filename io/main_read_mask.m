function V = main_read_mask(filename)

info = mha_read_header(filename);
mask = mha_read_volume(info); % mask

V = logical(mask);