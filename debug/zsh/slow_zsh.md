## Slow ZSH startup
Lately i noticed zsh startup is slow, almost taking around 800ms,

Benchmark zsh startup,
```bash
    for i in `seq 1 10`; do zsh -i -c exit; done
```

Compare with bash
```bash
    for i in `seq 1 10`; do zsh -i -c exit; done
```

while comparing with bash, which takes only 20 ms, so why zsh is
extremely slow?

This is how i figured it out,
