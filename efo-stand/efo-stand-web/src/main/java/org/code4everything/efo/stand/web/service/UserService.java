package org.code4everything.efo.stand.web.service;

import org.code4everything.boot.service.BootUserService;
import org.code4everything.efo.base.model.vo.user.RegisterVO;
import org.code4everything.efo.base.model.vo.user.UserInfoVO;
import org.code4everything.efo.stand.dao.domain.UserDO;

/**
 * @author pantao
 * @since 2019-04-11
 */
public interface UserService extends BootUserService<UserDO> {

    void updateUsername(String username);

    void updateEmail(String email, String code);

    void checkEmail(String email);

    void checkUsername(String username);

    UserDO getByUsernameOrEmail(String loginName);

    UserInfoVO register(RegisterVO registerVO);
}
