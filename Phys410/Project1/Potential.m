function v = Potential(r, nc, ts)

    v = 0;
    for i = 2: nc
        for j = 1: i - 1
            v = v + 1 / norm(r(i, :, ts) - r(j, : , ts));
        end
    end
end

