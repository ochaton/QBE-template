#include <qbe/all.h>

#include <stdio.h>

Target T;

static void readfn (Fn *fn) {
	for (Blk *blk = fn->start; blk; blk = blk->link) {
		printf("@%s", blk->name);
		printf("\n\tgen = ");

		if (blk->nins && Tmp0 <= blk->ins->to.val) {
			printf("@%s%%%s", blk->name, fn->tmp[blk->ins->to.val].name);
		}

		printf("\n\tkill =\n\n");
	}
}

static void readdat (Dat *dat) {
	(void) dat;
}

int main () {
	parse(stdin, "<stdin>", readdat, readfn);
	freeall();
}
