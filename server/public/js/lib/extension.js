Array.prototype.flatten = function() {
    return this.reduce(function (a, b) { return a.concat(b instanceof Array ? b.flatten() : b); }, []);
};
