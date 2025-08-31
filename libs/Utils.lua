local Utils={}
function Utils.Distance(a,b) return (a-b).Magnitude end
function Utils.IsValid(o) return o and o.Parent end
function Utils.Lerp(a,b,t) return a+(b-a)*t end
return Utils