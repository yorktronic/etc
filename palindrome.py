def isPalindrome(arg):
	# lower case of all characters
	arg = arg.lower()

	# create a set containing only unique values of arg
	chars = set(arg)
	
	# count how many characters have an odd count
	odd = 0
	for char in chars:
		if arg.count(char) % 2 != 0: odd += 1
	return (odd == 1)

# Tests

palindromes = ['amanaplanacanalpanama', 'ALULA', 'radar', 'rrdaa', 'madam', 'rotor', 'refer']
not_palindromes = ['taco', 'burrito', 'sushi', 'apple', 'obama']

print 'Testing Palindromes'
for palindrome in palindromes:
    print palindrome + " " + str(isPalindrome(palindrome))

print "\n"

print 'Testing non-palindromes'
for word in not_palindromes:
    print word + " " + str(isPalindrome(word))